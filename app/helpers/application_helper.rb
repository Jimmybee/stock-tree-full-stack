module ApplicationHelper
	include Pagy::Frontend

	def nav_link_to(name, path, icon: nil)
		active = current_page?(path)
		classes = [
			'nav-link',
			('nav-link-active' if active)
		].compact.join(' ')
		label = icon ? content_tag(:span, icon, class: 'nav-icon') + content_tag(:span, name, class: 'nav-text') : name
		link_to label.html_safe, path, class: classes
	end

	def primary_team
		return nil unless user_signed_in?
		@primary_team ||= current_user.teams.order(:created_at).first
	end
end
