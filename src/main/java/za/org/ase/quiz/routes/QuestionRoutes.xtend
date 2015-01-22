package za.org.ase.quiz.routes

import com.tobykurien.sparkler.transformer.JsonTransformer
import org.javalite.activejdbc.Model
import org.javalite.activejdbc.Paginator
import za.org.ase.quiz.models.Question

class QuestionRoutes extends BaseRoute {
   var question = Model.with(Question)
   
   override load() {
      get(new JsonTransformer(API_PREFIX + "/question") [req, res|
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
         q.set("name", req.queryParams("name"))
         q.saveIt
      ])

      put(new JsonTransformer(API_PREFIX + "/question") [req, res|
         question.createIt(
            "name", req.queryParams("name")
         )
      ])
      
      delete(new JsonTransformer(API_PREFIX + "/question/:id") [req, res|
         question.delete("id = ?", req.params("id"))
         #{ "success" -> true }
      ])
   }
   
}