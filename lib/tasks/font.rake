require 'open-uri'
require 'zip'
namespace :font do
  desc 'Prepare IPA fonts'
  task ipa: :environment do

    BASE_URL = 'http://dl.ipafont.ipa.go.jp/IPAexfont'
    TARGET = 'IPAexfont00301'
    DOWNLOAD_URL = BASE_URL + '/' + TARGET + '.zip'
    FOLDER = 'vendor/fonts'
    FILE_PATH = FOLDER + '/' + TARGET + '.zip'

    File.open(FILE_PATH, 'wb') do |saved_file|
      open(DOWNLOAD_URL, 'rb') do |read_file|
        saved_file.write(read_file.read)
      end
    end

    Zip::File.open(FILE_PATH) do |zip_file|
      zip_file.glob(TARGET + '/*.ttf').each do |entry|
        entry.extract(FOLDER + '/' + entry.to_s.split("/").last) { true }
        # puts entry.to_s
      end
    end

    File.delete FILE_PATH

  end
end
