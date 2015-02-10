package za.org.ase.quiz.models

import org.javalite.activejdbc.Model
import org.javalite.activejdbc.annotations.BelongsTo

@BelongsTo(foreignKeyName='question_id',parent=Question)
class Answer extends Model {
}