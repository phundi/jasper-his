class Encounter < ActiveRecord::Base
  self.table_name = :encounter
  self.primary_key = :encounter_id
  
  def name
  	EncounterType.find(self.encounter_type_id).name
  end
  
  def to_arr
  	Obs.where("encounter_id = #{self.id}").order("created_at ASC").collect{|o| 
  	
  		concept = "<b>" + Concept.find(o.concept_id).name + "</b>"
  		value = [o.value_text, o.value_numeric, o.value_datetime].delete_if{|v| v.blank?}
  		[concept, value]
  	}
  end
  
  def answer_string
  	
	self.to_arr.collect{|a| a.join(" :  ")}.join(", ")
  end
  
  def user
  	user = User.find(self.creator)
  	"#{user.first_name} #{user.middle_name} #{user.last_name}"
  end
end
