class EncounterController < ApplicationController
  skip_before_action :verify_authenticity_token

  def hiv_test_result
    @client = Client.find(params[:client_id])
    @client_type = ClientType.find(@client.client_type_id).name
    @trail_label = "HIV Test History"
    @result_type_options = ["Rapid Test", "Unigold Test"]
    @result_options = ["Negative", "Positive", "Inconclusive"]

    encounters = Encounter.where(client_id: params[:client_id],
                    encounter_type_id: EncounterType.where(name: "HIV Test").first.id).order(" encounter_datetime DESC")

    @data = []
    encounters.each do |encounter|
      @data << {
                   "title"   => encounter.name,
                   "content" => encounter.answer_string,
                   "data"    => encounter.to_arr,
                   "date"    => encounter.encounter_datetime.strftime("%Y-%b-%d  &nbsp; %H:%M"),
                   "user"    => encounter.user
               }
    end

    render :layout => "form"
  end

  def viral_load_result
    @client = Client.find(params[:client_id])
    @client_type = ClientType.find(@client.client_type_id).name
    @trail_label = "Viral Load History"
    @specimen_types = ["DBS", "Plasma"]

    encounters = Encounter.where(client_id: params[:client_id],
                                 encounter_type_id: EncounterType.where(name: "Viral Load").first.id).order(" encounter_datetime DESC")

    @data = []
    encounters.each do |encounter|
      @data << ({
          "title"   => encounter.name,
          "content" => encounter.answer_string,
          "data"    => encounter.to_arr,
          "date"    => encounter.encounter_datetime.strftime("%Y-%b-%d  &nbsp; %H:%M"),
          "user"    => encounter.user
      } rescue next)
    end

    render :layout => "form"
  end

  def outcomes
    @client = Client.find(params[:client_id])
    @client_type = ClientType.find(@client.client_type_id).name
    @trail_label = "Client Outcomes History"
    @outcomes = ["Died", "Transferred Out", "Lost to Followup", "On ART"]

    encounters = Encounter.where(client_id: params[:client_id],
                                 encounter_type_id: EncounterType.where(name: "Client Outcome").first.id).order(" encounter_datetime DESC")

    @data = []
    encounters.each do |encounter|
      @data << ({
          "title"   => encounter.name,
          "content" => encounter.answer_string,
          "data"    => encounter.to_arr,
          "date"    => encounter.encounter_datetime.strftime("%Y-%b-%d  &nbsp; %H:%M"),
          "user"    => encounter.user
      } rescue next)
    end

    render :layout => "form"
  end
  
  def create
  

    if params[:encounter_type].blank? || params[:obs].blank?

      flash[:error] = "Cant Save Empty Fields"
      redirect_to request.referrer and return
    end


    workflow_id = Workflow.where(name: params[:module]).first.id rescue nil
    if workflow_id.blank?
      flash[:error] = "Missing Module Name: '#{params[:module]}'"
      redirect_to request.referrer and return
    end

  
    encounter_type_id = EncounterType.where(name: params[:encounter_type]).first.id rescue nil
    if encounter_type_id.blank?
      flash[:error] = "Missing Encounter Type Name: '#{params[:encounter_type]}'"
      redirect_to request.referrer and return
    end

    encounter = Encounter.create(
      encounter_type_id:  encounter_type_id,
      workflow_id:        workflow_id,
      encounter_datetime: Time.now,
      client_id:          params[:client_id],
      creator:            session[:user_id]
    )

    (params[:obs] || []).each do |concept_name, data|
      next if concept_name.blank? || data.blank?
      concept_id = Concept.where(name: concept_name).first.id rescue nil

      (data || []).each do |type, values|
        next if values.blank? || type.blank?

        values = [values] if values.class == String

        (values || []).each do |value|
          Obs.create(
              "workflow_id"  => workflow_id,
              "encounter_id" => encounter.id,
              "concept_id" => concept_id,
              "#{type}" => value,
              "client_id" => params[:client_id],
              "obs_datetime" => Time.now,
              "creator"      => session[:user_id]
          )
        end
      end
    end

    redirect_to "/client/view?client_id=#{params[:client_id]}&module=#{params[:module]}"
  end
end
