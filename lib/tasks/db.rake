namespace :db do
 namespace :table do
    # Heroku to local
    desc 'table backup utility(ex.: rails db:table:backup[\'users;twitter;facebook\', kosen-robocon-db])'
    task :backup, [:tables, :app] => [:environment] do |t, args|
      tables = args["tables"].split(';')
      database_url = nil
      Bundler.with_clean_env { database_url = `heroku config:get DATABASE_URL --app=#{args["app"]}` }

      require 'addressable/uri'
      uri = Addressable::URI.parse(database_url)
      remote_database = uri.path[1,uri.path.length-2] # there is \n at the end of the path!

      tables.each do |table|
        backup_file = "tmp/#{table}.backup" # これもデフォルトと引数とで分けられるようにしないといけない
        # bin_dir = ""
        pg_dump = `which pg_dump` # パスが得られなかったときのエラー対処はまだ書いていない

        # dump_command = "PGPASSWORD=#{uri.password} #{bin_dir}/pg_dump --file \"#{backup_file}\" --host \"#{uri.host}\" --port \"#{uri.port}\" --username \"#{uri.user}\" --no-password --verbose --format=c --blobs --table \"public.#{table}\" \"#{remote_database}\""
        dump_command =  "PGPASSWORD=#{uri.password} #{pg_dump.chomp} "
        dump_command += "--file \"#{backup_file}\" --host \"#{uri.host}\" "
        dump_command += "--port \"#{uri.port}\" --username \"#{uri.user}\" "
        dump_command += "--no-password --verbose --format=c --blobs "
        dump_command += "--table \"public.#{table}\" \"#{remote_database}\""
        # puts dump_command
        `#{dump_command}`
        # `psql -U 'root' -d my_table -c 'drop table if exists #{table}'`
        # `pg_restore -d my_table --no-owner  #{backup_file}`

      end
    end

    # local to Heroku
    desc 'table restore utility(ex.: rails db:table:restore[\'users;twitter;facebook\', kosen-robocon-db])'
    task :restore, [:tables, :app] => :environment do |t, args|
    #   tables = args["tables"].split(';')
    #   database_url = nil
    #   Bundler.with_clean_env { database_url = `heroku config:get DATABASE_URL --app=#{args["app"]}` }
    #
    #   require 'addressable/uri'
    #   uri = Addressable::URI.parse(database_url)
    #   remote_database = uri.path[1,uri.path.length-2] # there is \n at the end of the path!
    #     # 上記までは共通化すべし
    #
    #   tables.each do |table|
    #     backup_file = "tmp/#{table}.backup" # これもデフォルトと引数とで分けられるようにしないといけない
    #     # bin_dir = ""
    #     pg_dump = `which pg_restore` # パスが得られなかったときのエラー対処はまだ書いていない
    #   end
    end
  end
end
