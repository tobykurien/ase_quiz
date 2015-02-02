package za.org.ase.quiz.routes

import com.tobykurien.sparkler.transformer.JsonTransformer
import java.util.Date
import org.javalite.activejdbc.Model
import org.javalite.activejdbc.Paginator
import za.org.ase.quiz.models.ActiveQuiz
import za.org.ase.quiz.models.Quiz

class QuizRoutes extends BaseRoute {
   var quiz = Model.with(Quiz)
   var activeQuiz = Model.with(ActiveQuiz)
   
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

      // activate a quiz      
      put(new JsonTransformer(API_PREFIX + "/activate_quiz") [req, res|
         val duration = Integer.parseInt(req.queryParams("duration"))
         val endDate = new Date(new Date().time + (duration*60*1000))
         
         activeQuiz.createIt(
            "quiz_id", req.queryParams("quiz_id"),
            "ends_at", endDate
         )
      ])

      delete(new JsonTransformer(API_PREFIX + "/quiz/:id") [req, res|
         quiz.delete("id = ?", req.params("id"))
         #{ "success" -> true }
      ])
   }
   
}