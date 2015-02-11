package za.org.ase.quiz.models

import org.javalite.activejdbc.Model
import org.javalite.activejdbc.annotations.BelongsTo

@BelongsTo(foreignKeyName='student_id',parent=Student)
class StudentAnswer extends Model {
      
}