package za.org.ase.quiz.routes

import com.tobykurien.sparkler.db.DatabaseManager
import org.javalite.activejdbc.Base
import org.javalite.activejdbc.Model
import spark.Request
import za.org.ase.quiz.models.Student

import static extension za.org.ase.quiz.Helper.*

class LoginRoutes extends BaseRoute {
   val student = Model.with(Student)
   
   override load() {
      get("/login") [ req, res |
         if (req.queryParams("username") == null) {
            render("views/login.html", #{})
         } else {
            doLogin(req)
            res.redirect("/")
            ""
         }
      ]

      post("/login") [ req, res |
         doLogin(req)
         if (req.isAdmin) res.redirect("/admin")
         else res.redirect("/")
         ""
      ]
      
      get("/logout") [req, res|
         req.setStudent(null)
         res.redirect("/")
         ""
      ]
   }

   def doLogin(Request req) {
      Base.open(DatabaseManager.newDataSource)
      try {
         var username = req.queryParams("username")

         // create user
         var Student ret
         var s = student.find("username =?", username)
         if (s.length == 0) {
            ret = student.createIt(
               "username", username
            )
         } else {
            ret = s.get(0)
         }

         req.student = ret
      } finally {
         Base.close
      }
   }   
}