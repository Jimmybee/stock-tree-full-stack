if Rails.env.development?
  begin
    require 'annotate'
    namespace :annotate do
      desc 'Annotate models'
      task models: :environment do
        Annotate.load_tasks
        Rake::Task['annotate_models'].invoke
      end
    end

    # Auto-annotate after migrations
    Rake::Task['db:migrate'].enhance do
      Rake::Task['annotate:models'].invoke
    end
  rescue LoadError
    # annotate gem not present; skip
  end
end
