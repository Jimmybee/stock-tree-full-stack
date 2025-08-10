# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
	config.content_security_policy do |policy|
		policy.default_src :self, :https
		policy.font_src    :self, :https, :data
		policy.img_src     :self, :https, :data, :blob
		policy.object_src  :none
		policy.script_src  :self, :https
		policy.style_src   :self, :https
		policy.connect_src :self, :https
		# Allow websocket in dev
		if Rails.env.development?
			policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035", "ws://localhost:3000"
			policy.script_src  :self, :https, :unsafe_eval
			policy.style_src   :self, :https, :unsafe_inline
		end
	end

	# Generate session nonces for permitted importmap, inline scripts, and inline styles.
	config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
	config.content_security_policy_nonce_directives = %w(script-src style-src)

	# Report-only mode can be enabled by env var
	if ENV["CSP_REPORT_ONLY"] == "1"
		config.content_security_policy_report_only = true
	end
end
