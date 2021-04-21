# frozen_string_literal: true

module EpisodesHelper
  def rating_stars(rating)
    return if rating.blank?

    nut_num, dec_num = rating.to_s.split('.').map(&:to_i)

    stars = [0, 0, 0, 0, 0]
    stars.fill(2, 0, nut_num)
    stars.fill(1, nut_num, 1) unless dec_num == 0

    stars = stars.map do |star|
      case star
      when 0 then icon('star', 'far')
      when 1 then icon('star-half')
      when 2 then icon('star')
      end
    end

    stars.join.html_safe
  end
end
