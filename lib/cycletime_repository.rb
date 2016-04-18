require 'orchestrate'

class CycletimeRepository
  def initialize(api_key, collection, endpoint)
    @api_key = api_key
    @collection = collection
    @endpoint = endpoint
  end

  def fetch(board_id)
    app = Orchestrate::Application.new(@api_key, @endpoint)
    data = app[@collection]

    metrics = data.search("board_id: #{board_id}").order(:end_time, :asc)
    return 200 if metrics == []

    cycle_times = metrics.find.collect do |m|
      score = m[0]
      metric = m[1].value
      {card: metric["id"], name: metric["name"], cycle_time: metric["cycle_time"], estimate: metric["estimate"], end_time: metric["end_time"]}
    end

    cycle_times
  end
end