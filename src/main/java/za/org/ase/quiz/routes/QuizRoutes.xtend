package za.org.ase.quiz.routes

import com.tobykurien.sparkler.transformer.JsonTransformer
import com.tobykurien.sparkler.transformer.RestfulException
import java.util.Date
import org.javalite.activejdbc.Model
import org.javalite.activejdbc.Paginator
import za.org.ase.quiz.models.Quiz

class QuizRoutes extends BaseRoute {
   var quiz = Model.with(Quiz)
   
   override load() {
      get(new JsonTransformer(API_PREFIX + "/quiz_active") [req, res|
         var pageSize = 10
         var paginator = new Paginator(Quiz, pageSize, "ends_at > ?", new Date()).orderBy("id desc");
         var page = try { Integer.parseInt(req.queryParams("page")) } catch (Exception e) { 1 };
         var result = paginator.getPage(page)
         #{
            'count' -> paginator.count,
            'pages' -> paginator.pageCount,
            'results' -> result.toMaps
          }
      ])

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
         if (!req.isAdmin) {
            throw new RestfulException(401, "Unauthorized")
         }

         var q = quiz.findById(req.params("id"))
         if (req.queryParams("name") != null) q.set("name", req.queryParams("name"));
         if (req.queryParams("duration") != null) {
            val duration = Integer.parseInt(req.queryParams("duration"))
            val endDate = new Date(new Date().time + (duration*60*1000))
            q.set("ends_at", endDate);
         }
         
         q.saveIt
      ])

      put(new JsonTransformer(API_PREFIX + "/quiz") [req, res|
         if (!req.isAdmin) {
            throw new RestfulException(401, "Unauthorized")
         }

         quiz.createIt(
            "name", req.queryParams("name")
         )
      ])

      delete(new JsonTransformer(API_PREFIX + "/quiz/:id") [req, res|
         if (!req.isAdmin) {
            throw new RestfulException(401, "Unauthorized")
         }

         quiz.delete("id = ?", req.params("id"))
         #{ "success" -> true }
      ])
   }
   
}