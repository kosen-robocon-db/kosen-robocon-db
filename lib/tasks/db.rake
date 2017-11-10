namespace :heroku do
 namespace :table do

    # Heroku to local
    d = <<-EOS.strip_heredoc
      table backup utility(ex.:
      rails heroku:table:backup[\'twitter;facebook\', kosen-robocon-db])
    EOS
      # <<~ が使えなかった
    desc d.gsub(/(\r\n|\r|\n|\f)/,"")
    task :backup, [:tables, :app] => [:environment] do |t, args|
      tables = args["tables"].split(';')
      database_url = nil
      Bundler.with_clean_env { database_url =
        `heroku config:get DATABASE_URL --app=#{args["app"]}` }

      require 'addressable/uri'
      uri = Addressable::URI.parse(database_url)
      remote_database = uri.path[1,uri.path.length-2]
        # there is \n at the end of the path!

      tables.each do |table|
        backup_file = "tmp/#{table}.backup"
          # これもデフォルトと引数とで分けられるようにしないといけない
        pg_dump = `which pg_dump`
          # パスが得られなかったときのエラー対処はまだ書いていない
          # この pg_dump のバージョンはサーバーのバージョンより上位でないといけない

        dump_command =  "PGPASSWORD=#{uri.password} #{pg_dump.chomp} "
        dump_command += "--file \"#{backup_file}\" --host \"#{uri.host}\" "
        dump_command += "--port \"#{uri.port}\" --username \"#{uri.user}\" "
        dump_command += "--no-password --verbose --format=c --blobs "
        dump_command += "--table \"public.#{table}\" \"#{remote_database}\""
        `#{dump_command}`
        # `psql -U 'root' -d my_table -c 'drop table if exists #{table}'`
        # `pg_restore -d my_table --no-owner  #{backup_file}`
          # もしローカルのサーバーに移したければ上記二行を実行
          # オプションで実行可能にすればよいが、実装は将来に持ち越し

        # （内容確認などのために）ダウンロードしたダンプファイルをSQLにする：
        # $ pg_restore -U postgres pg.dump > pg.sql
        # オプションで実行可能にすればよいが、実装は将来に持ち越し
      end
    end
  end
end
