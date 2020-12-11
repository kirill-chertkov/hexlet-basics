# frozen_string_literal: true

class DockerExerciseApi
  def self.download(lang_name)
    system("docker pull hexletbasics/exercises-#{lang_name}")
    system("rm -rf /var/tmp/hexletbasics/exercises-#{lang_name}")

    # FIXME docker in docker volume
    system("docker run --name exercises-#{lang_name} -v /var/tmp/hexletbasics/exercises-#{lang_name}:/out hexletbasics/exercises-#{lang_name}")
    system("docker cp exercises-#{lang_name}:/exercises-#{lang_name} /var/tmp/hexletbasics/")
    system("docker rm exercises-#{lang_name}")

    "/var/tmp/hexletbasics/exercises-#{lang_name}"
  end

  def self.tag_image_version(lang_name, tag)
    return if Rails.env.production?

    tag_command = "docker tag hexletbasics/exercises-#{lang_name}:latest hexletbasics/exercises-#{lang_name}:#{tag}"
    ok = BashRunner.start(tag_command)

    push_command = "docker push hexletbasics/exercises-#{lang_name}:#{tag}"
    ok = BashRunner.start(push_command)

    # FIXME better error handling
    raise "Docker tag error" unless ok
  end
end
