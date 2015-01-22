package za.org.ase.quiz.models

import org.javalite.activejdbc.Model
import org.javalite.activejdbc.annotations.BelongsTo

@BelongsTo(foreignKeyName='quiz_id',parent=Quiz)
class Question extends Model {
   
}