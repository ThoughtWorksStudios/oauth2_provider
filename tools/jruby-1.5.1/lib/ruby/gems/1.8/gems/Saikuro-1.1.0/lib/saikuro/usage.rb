# This is a patch to RDoc so that when saikuro is installed as a
# RubyGem usage will read the proper file.

require 'rdoc/usage'

module RDoc

  def RDoc.main_program_file=(file)
    @@main_program_file = file
  end

  # Display usage
  def RDoc.usage_no_exit(*args)
    @@main_program_file ||= caller[-1].sub(/:\d+$/, '')
    comment = File.open(@@main_program_file) do |file|
      find_comment(file)
    end

    comment = comment.gsub(/^\s*#/, '')

    markup = SM::SimpleMarkup.new
    flow_convertor = SM::ToFlow.new

    flow = markup.convert(comment, flow_convertor)

    format = "plain"

    unless args.empty?
      flow = extract_sections(flow, args)
    end

    options = RI::Options.instance
    if args = ENV["RI"]
      options.parse(args.split)
    end
    formatter = options.formatter.new(options, "")
    formatter.display_flow(flow)
  end
end
