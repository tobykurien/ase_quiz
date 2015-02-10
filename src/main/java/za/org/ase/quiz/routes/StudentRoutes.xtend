package za.org.ase.quiz.routes

import com.tobykurien.sparkler.db.DatabaseManager
import org.javalite.activejdbc.Base
import org.javalite.activejdbc.Model
import za.org.ase.quiz.models.Quiz
import za.org.ase.quiz.models.Question
import za.org.ase.quiz.models.Answer

class StudentRoutes extends BaseRoute {
   var quiz = Model.with(Quiz)
   var question = Model.with(Question)
   
   override load() {
      get('/take_quiz') [req, res|
         var quizId = Integer.parseInt(req.queryParams("quiz_id"))

         Base.open(DatabaseManager.newDataSource)
         try {
            var questionId = -1
            if (req.queryParams("question_id") != null) {
               questionId = Integer.parseInt("question_id")
            }
         
            var qz = quiz.findById(quizId)
            var questions = qz.get(Question, null).map[ id ]            

            var qstn = if (questionId <= 0) {
               question.findById(questions.get(0))
            } else {
               question.findById(questionId)
            }
            
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
   }
   
}