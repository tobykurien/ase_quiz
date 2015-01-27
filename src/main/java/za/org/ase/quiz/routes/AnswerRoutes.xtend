package za.org.ase.quiz.routes

import com.tobykurien.sparkler.transformer.JsonTransformer
import org.javalite.activejdbc.Model
import org.javalite.activejdbc.Paginator
import za.org.ase.quiz.models.Answer

class AnswerRoutes extends BaseRoute {
   var answer = Model.with(Answer)
   
   override load() {

      get(new JsonTransformer(API_PREFIX + "/answers") [req, res|
         var pageSize = 10
         var paginator = new Paginator(Answer, pageSize, "question_id = ?", req.queryParams("questionId")).orderBy("id");
         var page = try { Integer.parseInt(req.queryParams("page")) } catch (Exception e) { 1 };
         var result = paginator.getPage(page)
         #{
            'count' -> paginator.count,
            'pages' -> paginator.pageCount,
            'results' -> result.toMaps
          }
      ])

      get(new JsonTransformer(API_PREFIX + "/answer/:id") [req, res|
         answer.findById(req.params("id"))
      ])
      
      post(new JsonTransformer(API_PREFIX + "/answer/:id") [req, res|
         var q = answer.findById(req.params("id"))
         q.set("answer", req.queryParams("answer"))
         q.set("correct", req.queryParams("correct"))
         q.saveIt
      ])

      put(new JsonTransformer(API_PREFIX + "/answer") [req, res|
         answer.createIt(
            "question_id", req.queryParams("questionId"),
            "answer", req.queryParams("answer"),
            "correct", req.queryParams("correct")
         )
      ])
      
      delete(new JsonTransformer(API_PREFIX + "/answer/:id") [req, res|
         answer.delete("id = ?", req.params("id"))
         #{ "success" -> true }
      ])
   }
   
}