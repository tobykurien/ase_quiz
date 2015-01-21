package za.org.ase.quiz.routes

import com.tobykurien.sparkler.transformer.JsonTransformer
import org.javalite.activejdbc.Model
import za.org.ase.quiz.models.Quiz

class QuizRoutes extends BaseRoute {
   var quiz = Model.with(Quiz)
   
   override load() {
      get(new JsonTransformer(API_PREFIX + "/quiz") [req, res|
         quiz.findAll
      ])

      get(new JsonTransformer(API_PREFIX + "/quiz/:id") [req, res|
         quiz.findById(req.queryParams("id"))
      ])
      
      post(new JsonTransformer(API_PREFIX + "/quiz/:id") [req, res|
         var q = quiz.findById(req.queryParams("id"))
         q?.set("name", req.queryParams("name"))
      ])

      put(new JsonTransformer(API_PREFIX + "/quiz") [req, res|
         quiz.createIt(
            "name", req.queryParams("name")
         )
      ])
      
      delete(new JsonTransformer(API_PREFIX + "/quiz/:id") [req, res|
         quiz.findById(req.queryParams("id"))?.deleteCascade
         #{ "success" -> true }
      ])
   }
   
}