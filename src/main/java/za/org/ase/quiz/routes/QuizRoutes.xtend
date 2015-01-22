package za.org.ase.quiz.routes

import com.tobykurien.sparkler.transformer.JsonTransformer
import org.javalite.activejdbc.Model
import za.org.ase.quiz.models.Quiz
import org.javalite.activejdbc.Paginator

class QuizRoutes extends BaseRoute {
   var quiz = Model.with(Quiz)
   
   override load() {
      get(new JsonTransformer(API_PREFIX + "/quiz") [req, res|
         var pageSize = 10
         var paginator = new Paginator(Quiz, pageSize, "true").orderBy("id desc");
         var page = try { Integer.parseInt(req.queryParams("page")) } catch (Exception e) { 1 };
         var result = paginator.getPage(page)
         #{
            'count' -> paginator.count,
            'pages' -> paginator.pageCount,
            'results' -> result.toMaps
          }
      ])

      get(new JsonTransformer(API_PREFIX + "/quiz/:id") [req, res|
         quiz.findById(req.params("id"))
      ])
      
      post(new JsonTransformer(API_PREFIX + "/quiz/:id") [req, res|
         var q = quiz.findById(req.params("id"))
         q.set("name", req.queryParams("name"))
         q.saveIt
      ])

      put(new JsonTransformer(API_PREFIX + "/quiz") [req, res|
         quiz.createIt(
            "name", req.queryParams("name")
         )
      ])
      
      delete(new JsonTransformer(API_PREFIX + "/quiz/:id") [req, res|
         quiz.delete("id = ?", req.params("id"))
         #{ "success" -> true }
      ])
   }
   
}