package za.org.ase.quiz.routes

import com.tobykurien.sparkler.db.DatabaseManager
import com.tobykurien.sparkler.transformer.JsonTransformer
import com.tobykurien.sparkler.transformer.RestfulException
import org.javalite.activejdbc.Base
import org.javalite.activejdbc.Model
import za.org.ase.quiz.models.Answer
import za.org.ase.quiz.models.Question
import za.org.ase.quiz.models.Quiz
import za.org.ase.quiz.models.StudentAnswer

/**
 * Routes for students taking (answering) a quiz 
 */
class StudentRoutes extends BaseRoute {
   var quiz = Model.with(Quiz)
   var question = Model.with(Question)
   var studentAnswer = Model.with(StudentAnswer)
   
   override load() {
      // get the Quiz, it's questions and it's answers
      get('/take_quiz') [req, res|
         var quizId = Integer.parseInt(req.queryParams("quiz_id"))

         Base.open(DatabaseManager.newDataSource)
         try {
            var questionId = -1
            if (req.queryParams("question_id") != null) {
               questionId = Integer.parseInt(req.queryParams("question_id"))
            }
         
            var qz = quiz.findById(quizId)
            var questions = qz.get(Question, null).map[ id ]            

            var qstn = if (questionId <= 0) {
               question.findById(questions.get(0))
            } else {
               question.findById(questionId)
            }

            // change the template based on question type            
            var template = switch (qstn.getInteger("question_type_id")) {
               case 0: "views/question_multiple_choice.html"
               case 1: "views/question_short_answer.html"
            }
            
            render(template, #{
               "quiz" -> qz.toMap,
               "questions" -> questions,
               "question" -> qstn.toMap,
               "answers" -> qstn.get(Answer, null).toMaps
            })
         } finally {
            Base.close
         }
      ]
      
      // save an answer entered by student for a question
      put(new JsonTransformer(API_PREFIX + "/student_answer/:question_id") [req, res|
            // TODO security check: is student logged in?
         
            // get answer data
            var answerId = try { 
               Integer.parseInt(req.queryParams("answer_id"))
            } catch (Exception e) {
               -1
            }
            var answerText = req.queryParams("answer_text")
            
            // check if question is valid
            var questionId = Integer.parseInt(req.params("question_id"))
            var qstn = question.findById(questionId)
            if (qstn == null) {
               throw new RestfulException(404, "Question not found")
            }
            
            // make sure the quiz is still active
            var qz = quiz.findById(qstn.getLong("quiz_id"))
            if (qz == null || !qz.isActive) {
               throw new RestfulException(404, "Quiz expired " + qz)
            }
   
            // process the correctness of the answer
            var correct = false
            var points = 0L
            var correctAnswers = qstn.get(Answer, "correct = ?", true)
            if (correctAnswers != null && correctAnswers.length > 0) {
               for (ans : correctAnswers) {
                  if (ans.isCorrect(qstn.getInteger("question_type_id"), answerId, answerText)) {
                     correct = true
                     points += qstn.points
                  }
               }
            } else {
               // This question has no correct answer loaded! What do? 
            }
   
            // save the answer data
            var prevAnswer = studentAnswer.findFirst(
               "question_id = ? and student_id = ?", questionId, req.student.id)

            if (prevAnswer != null) {
               // update previous answer
               prevAnswer.set(
                  "answer_id", answerId,
                  "answer_text", answerText,
                  "correct", correct,
                  "points", points
               )
               prevAnswer.saveIt
            } else {
               // save new answer
               prevAnswer = studentAnswer.createIt(
                  "question_id", questionId,
                  "student_id", req.student.id,
                  "answer_id", answerId,
                  "answer_text", answerText,
                  "correct", correct,
                  "points", points
               )
            }
            
            return prevAnswer
      ])
   }
   
}