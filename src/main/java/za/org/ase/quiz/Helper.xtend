package za.org.ase.quiz

import spark.Request
import za.org.ase.quiz.models.Student

/**
 * Utility extension methods
 */
class Helper {
   // Are we running in development environment?
   def static isDev() {
      val String env = com.tobykurien.sparkler.Helper.environment as String
      if ("development".equalsIgnoreCase(env)) {
         true
      } else {
         false
      }
   }
   
   // Get the student from the session   
   def static getStudent(Request request) {
      request.session(true).attribute("student") as Student
   }

   // Set the student into the session   
   def static setStudent(Request request, Student student) {
      request.session(true).attribute("student", student)
   }
   
   // Is this user an admin?
   def static isAdmin(Request request) {
      getStudent(request).get("username").equals("teacher")
   }
}