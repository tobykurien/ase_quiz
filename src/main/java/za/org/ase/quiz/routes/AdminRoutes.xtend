package za.org.ase.quiz.routes

import com.tobykurien.sparkler.db.DatabaseManager
import org.javalite.activejdbc.Base
import org.javalite.activejdbc.Model
import za.org.ase.quiz.models.Quiz

import static extension za.org.ase.quiz.Helper.*

class AdminRoutes extends BaseRoute {
   var quiz = Model.with(Quiz)
   
   override load() {
      before("/admin") [req, res, filter|
         if (!req.isAdmin) {
            filter.haltFilter(401, "Unauthorized")
         }
      ]
      
      get("/admin") [req, res|
         render("views/admin/index.html", #{})
      ]

      get("/admin/questions/:quizId") [req, res|
         try {
            Base.open(DatabaseManager.newDataSource)
            
            render("views/admin/quiz_questions.html", #{ 
               'quiz' -> quiz.findById(req.params("quizId")).toMap
            })
         } finally {
            Base.close()
         }
      ]
   }
   
}