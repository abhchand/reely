class DateRangeLabelService
  def self.call(photos)
    new(photos).generate_label
  end

  def generate_label
    return if first_photo.blank? || last_photo.blank?

    parse_start_date!
    parse_end_date!

    case
    when same_day?
      [@s_day, @s_month, @s_year].join(" ")
    when same_month?
      ["#{@s_day} - #{@e_day}", @s_month, @s_year].join(" ")
    when same_year?
      ["#{@s_day} #{@s_month} - #{@e_day} #{@e_month}", @s_year].join(" ")
    else
      [
        [@s_day, @s_month, @s_year].join(" "),
        [@e_day, @e_month, @e_year].join(" ")
      ].join(" - ")
    end
  end

  private

  def initialize(photos)
    @photos = photos
  end

  def first_photo
    @first_photo ||= @photos.min_by(&:taken_at)
  end

  def last_photo
    @last_photo ||= @photos.max_by(&:taken_at)
  end

  def parse_start_date!
    @s_day, @s_month, @s_year = parse_date(first_photo.taken_at)
  end

  def parse_end_date!
    @e_day, @e_month, @e_year = parse_date(last_photo.taken_at)
  end

  def parse_date(date)
    date.strftime(I18n.t("time.formats.day_month_and_year")).split
  end

  def same_day?
    @s_day == @e_day && same_month?
  end

  def same_month?
    @s_month == @e_month && same_year?
  end

  def same_year?
    @s_year == @e_year
  end
end
