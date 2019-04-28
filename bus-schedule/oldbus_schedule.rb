# form_minutes_xxの時点でhourも付けた方が楽かも

require 'nokogiri'
require 'open-uri'
require 'json'

class GetBusSchedule
    attr_reader :urls, :shosfc, :shosfc_t, :tsujisfc, :tsujisfc_t

    def initialize(urls = {})
        @urls = []
        @shosfc = urls[:shosfc]
        @shosfc_t = urls[:shosfc_t]
        @tsujisfc = urls[:tsujisfc]
        @urls << shosfc
    end

    def get_minutes(url)
        charset = 'utf-8'
        html =
            open(url) do |f|
                f.read
            end

        doc = Nokogiri::HTML.parse(html, nil, charset)
        doc.xpath('//div[@class="time"]').map do |node|
            sleep(0.5)
            node.text.scan(/\d\d/)
        end
    end

    def minute_model
        [
            {"weekday" => []},
            {"sat" => []},
            {"sun" => []}
        ]
    end

    def form_minutes_shosfc
        not_organized_schedules = get_minutes(shosfc)

        organized_minute =
        not_organized_schedules.inject(minute_model) do |m_model, element|
            case element
            when proc {|ary| not_organized_schedules.index(ary) % 3 == 1}
                m_model[1]["sat"] << element.map(&:to_i)
            when proc {|ary| not_organized_schedules.index(ary) % 3 == 0}, proc {m_model[2]["sun"].size == 13}
                m_model[0]["weekday"] << element.map(&:to_i)
            when proc {|ary| not_organized_schedules.index(ary) % 3 == 2}
                m_model[2]["sun"] << element.map(&:to_i)
            end
            m_model
        end

        Hash["shosfc", organized_minute]
    end

    def form_minutes_shosfc_t
        not_organized_schedules = get_minutes(shosfc_t)

        organized_minute = minute_model
        organized_minute.delete_at(2)

        not_organized_schedules.each_slice(2) do |weekday, sat|
            organized_minute[0]["weekday"] << weekday.map(&:to_i)
            organized_minute[1]["sat"]<< sat.map(&:to_i)
        end

        organized_minute.each_slice(2) do |weekday_hash, sat_hash|
            sat = weekday_hash["weekday"].slice!(6,2)
            weekday = sat_hash["sat"].slice!(6,2)
            weekday_hash["weekday"][6, 0] = weekday
            sat_hash["sat"][6, 0] = sat
        end

        Hash["shosfc_t", organized_minute]
    end

    def form_minutes_tsujisfc
        not_organized_schedules = get_minutes(tsujisfc)
        organized_minute = minute_model

        organized_minute[0]["weekday"] << not_organized_schedules.shift.map(&:to_i)
        organized_minute[1]["sat"] << not_organized_schedules.shift.map(&:to_i)

        not_organized_schedules.each_slice(3) do |m_1, m_2, m_3|
            organized_minute[0]["weekday"] << m_1.map(&:to_i)
            organized_minute[1]["sat"] << m_2.map(&:to_i)
            organized_minute[2]["sun"] << m_3.map(&:to_i) if m_3
        end

        # 各organized_minuteの12番目以降を取り出す sunは11以降
        wrong_schedules = 
        organized_minute.map { |xx_day|
            if xx_day.has_key?("weekday")
                xx_day["weekday"].slice!(12..13)
            elsif xx_day.has_key?("sat")
                xx_day["sat"].slice!(12..13)
            else
                xx_day["sun"].slice!(11)
            end
        }.flatten
    end

    def form_minutes_tsujisfc_t

    end
end

shosfc = 'http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000801156-1/nid:00129893/rt:0/k:%E6%B9%98%E5%8D%97%E5%8F%B0%E9%A7%85%E8%A5%BF%E5%8F%A3'
shosfc_t = 'http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000802604-1/nid:00129893/rt:0/k:%E6%B9%98%E5%8D%97%E5%8F%B0%E9%A7%85%E8%A5%BF%E5%8F%A3'

tsujisfc = 'http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000802702-1/nid:00129934/rt:0/k:%E8%BE%BB%E5%A0%82%E9%A7%85%E5%8C%97%E5%8F%A3/dts:1543773600'
tsujisfc_t = 'http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000802714-1/nid:00129934/rt:0/k:%E8%BE%BB%E5%A0%82%E9%A7%85%E5%8C%97%E5%8F%A3/dts:1543773600'

bus_schedule = GetBusSchedule.new(
    shosfc: shosfc,
    shosfc_t: shosfc_t,
    tsujisfc: tsujisfc,
    tsujisfc_t: tsujisfc_t
)
p bus_schedule.form_minutes_tsujisfc
