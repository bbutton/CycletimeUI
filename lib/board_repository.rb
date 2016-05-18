require 'mysql2'

class BoardRepository
  def initialize(db_url, db_port, db_user, db_password, db_name)
    @client = Mysql2::Client.new(:host => db_url, :port => db_port, :username => db_user, :password => db_password, :database => db_name)
  end

  def start_update_for_board(board_id)
    results = @client.query("update boards set interrupted = 'Y', end_time = NULL where board_id = '" + board_id + "'")
  end

  def get_board_status(board_id)
    result = @client.query("select start_time, end_time, interrupted from boards where board_id = '" + board_id + "'")
    first = result.first
    start_time = first["start_time"]
    end_time = first["end_time"]
    interrupted = first["interrupted"]

    result = "Last updated at " + end_time.to_s
    if((start_time == nil) or (interrupted == "Y")) then
      result = "- Waiting to start"
    elsif(end_time == nil) then
      result = "- Updating"
    end

    result
  end

  def start_updating(board_id_to_load)

  end

  def find_board_to_load
    @client.query("START TRANSACTION")
    results = @client.query("select board_id from boards where interrupted = 'Y' or (start_time is NULL and end_time is NULL) order by id limit 1")

    if results.first == nil
      @client.query("commit")
      return nil
    end

    board_id = results.first["board_id"]
    @client.query("update boards set start_time = UTC_TIMESTAMP(), interrupted = null where board_id = '" + board_id + "'")
    @client.query("commit")

    board_id
  end

  def complete_updating(board_id)
    @client.query("update boards set end_time = UTC_TIMESTAMP() where board_id = '" + board_id + "'")
  end

  def set_interrupted(board_id)
    @client.query("update boards set interrupted = 'Y' where board_id = '" + board_id + "'")
  end
end