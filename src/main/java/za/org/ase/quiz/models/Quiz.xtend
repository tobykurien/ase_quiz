package za.org.ase.quiz.models

import java.util.Date
import org.javalite.activejdbc.Model

class Quiz extends Model {
   
   def getIsActive() {
      getDate("ends_at").time < new Date().time
   }
   
}