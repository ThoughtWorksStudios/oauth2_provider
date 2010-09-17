require 'rdoc/usage'

# fix to work with rubygems (use current file instead of main)
def RDoc.usage_no_exit(*args)
  comment = File.open(File.join(File.dirname(__FILE__), %w(.. .. .. bin), File.basename($0))) do |file|
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
