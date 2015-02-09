package za.org.ase.quiz.routes

import za.org.ase.quiz.routes.BaseRoute

class StudentRoutes extends BaseRoute {
   
   override load() {
      get('/take_quiz') [req, res|
         render("views/take_quiz.html", {
            
         })
      ]
   }
   
}