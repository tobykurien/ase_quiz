package za.org.ase.quiz.models

import com.tobykurien.sparkler.db.DbField
import java.util.Date
import org.javalite.activejdbc.Model

class Quiz extends Model {
   @DbField String name
   @DbField Date createdAt 
   @DbField Date updatedAt 
   @DbField Date endsAt

   val static validations = {
      validatePresenceOf("name")
   }
   
   def getIsActive() {
      getDate("ends_at").after(new Date())
   }
   
}