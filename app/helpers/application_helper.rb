module ApplicationHelper
	def load_templates(*args)
		types = nil
		if args[0].is_a?(Array)
			types = args[0]
		end
		templates = '';
		Dir["app/views/application/js_templates/*"].each do |file|
			name = File.basename(file, ".html.erb")
			type = name.split("_")[2]
			if (not types.nil?) and (not types.include? type)
				next
			end
			templates = templates + '<script type="text/template" class="' + name.split("_").last.html_safe + '_template" id="' + name + '_template">' +
				render(:file => Rails.root.join(file).to_s) +
			'</script>'
		end
		templates.html_safe
	end
end
