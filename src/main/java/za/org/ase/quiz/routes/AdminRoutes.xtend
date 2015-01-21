package za.org.ase.quiz.routes

import za.org.ase.quiz.routes.BaseRoute

import static extension za.org.ase.quiz.Helper.*

class AdminRoutes extends BaseRoute {
   
   override load() {
      before("/admin") [req, res, filter|
         if (!req.isAdmin) {
            filter.haltFilter(401, "Unauthorized")
         }
      ]
      
      get("/admin") [req, res|
         render("views/admin/index.html", #{})
      ]
   }
   
}