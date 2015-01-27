package za.org.ase.quiz.routes

import com.tobykurien.sparkler.transformer.JsonTransformer
import org.javalite.activejdbc.Model
import org.javalite.activejdbc.Paginator
import za.org.ase.quiz.models.Question

class QuestionRoutes extends BaseRoute {
   var question = Model.with(Question)
   
   override load() {
      get(new JsonTransformer(API_PREFIX + "/questions") [req, res|
         var pageSize = 10
         var paginator = new Paginator(Question, pageSize, "quiz_id = ?", req.queryParams("quizId")).orderBy("id");
         var page = try { Integer.parseInt(req.queryParams("page")) } catch (Exception e) { 1 };
         var result = paginator.getPage(page)
         #{
            'count' -> paginator.count,
            'pages' -> paginator.pageCount,
            'results' -> result.toMaps
          }
      ])

      get(new JsonTransformer(API_PREFIX + "/question/:id") [req, res|
         question.findById(req.params("id"))
      ])
      
      post(new JsonTransformer(API_PREFIX + "/question/:id") [req, res|
         var q = question.findById(req.params("id"))
         q.set("question", req.queryParams("question"))
         q.set("question_type_id", req.queryParams("question_type_id"))
         q.set("points", req.queryParams("points"))
         q.saveIt
      ])

      put(new JsonTransformer(API_PREFIX + "/question") [req, res|
         question.createIt(
            "quiz_id", req.queryParams("quizId"),
            "question", req.queryParams("question"),
            "question_type_id", req.queryParams("question_type_id"),
            "points", req.queryParams("points")
         )
      ])
      
      delete(new JsonTransformer(API_PREFIX + "/question/:id") [req, res|
         question.delete("id = ?", req.params("id"))
         #{ "success" -> true }
      ])
   }
   
}