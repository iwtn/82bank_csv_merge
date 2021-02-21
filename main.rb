require 'csv'
require 'date'

OUTPUT_FILENAME = 'merged.csv'

row_hash = {}
Dir.glob("csv/*.csv").each do |file|
  next if file == "csv/#{OUTPUT_FILENAME}"
  CSV.foreach(file, encoding: "Shift_JIS:UTF-8") do |row|
    unless row[0] == "八十二銀行"
      id = row[0]
      date = Date.parse(row[1])
      out_amount = row[2].to_i
      in_amount = row[3].to_i
      detail = row[4]

      row_hash[id] = {
        date: Date.parse(row[1]),
        out_amount: row[2]&.to_i,
        in_amount: row[3]&.to_i,
        detail: row[4],
        balance: row[5].to_i,
      }
    end
  end
end

CSV.open("csv/#{OUTPUT_FILENAME}", 'w') do |csv|
  csv << %w(id 取引日 収入 支出 明細 残高)
  row_hash.keys.sort.each do |key|
    row = row_hash[key]
    csv << [key, row[:date], row[:out_amount], row[:in_amount], row[:detail], row[:balance]]
  end
end
