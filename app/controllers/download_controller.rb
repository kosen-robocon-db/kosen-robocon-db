class DownloadController < ApplicationController
  def index
    zipfile_name = "tmp/download.zip"
    delete_if_exist(zipfile_name)
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      models = %w(Robot Game PrizeHistory RobotCondition GameDetail AdvancementHistory)
      models.each do |model|
        csvfile_name = model.tableize + ".csv"
        delete_if_exist("tmp/" + csvfile_name)
        File.write("tmp/" + csvfile_name, Object.const_get(model).all.order_csv.to_csv)
        zipfile.add(csvfile_name, "tmp/" + csvfile_name)
      end
    end
    send_file zipfile_name
  end

  private

  def delete_if_exist(file_name)
    if File.exist?(file_name)
      File.delete(file_name)
    end
  end
end


