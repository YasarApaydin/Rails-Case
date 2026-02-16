require "google/apis/sheets_v4"
require "googleauth"

module GoogleSheets
  class ProductsSyncService
    SHEET_ID = ENV["GOOGLE_SHEET_ID"]
    RANGE = "Sayfa1!A2:J"

    def initialize
      @service = Google::Apis::SheetsV4::SheetsService.new
      @service.authorization = authorize
    end


 
    def sync_from_sheet
      response = @service.get_spreadsheet_values(SHEET_ID, RANGE)
      rows = response.values || []
      rows.each_with_index do |row, index|
        external_id = row[0]
        name        = row[1]
        price       = row[2]
        stock       = row[3]
        category    = row[4]
        product =
        if external_id.present?
          Product.find_by(id: external_id) || Product.new
        else
          Product.new
        end
        product.assign_attributes(
          name: name,
          price: price,
          stock: stock,
          category: category,
          is_deleted: false,
          deleted_at: nil
        )
        if product.save
          update_sheet_id(index + 2, product.id) if external_id.blank?
          clear_error_from_sheet(index + 2)
        else
          write_error_to_sheet(index + 2, product.errors.full_messages.join(", "))
        end
      end
    end



    def sync_to_sheet
      products = Product.unscoped.all
      return if products.empty?
      clear_request = {
        update_cells: {
          range: {
            sheet_id: sheet_id,
            start_row_index: 1,  
            start_column_index: 0,
            end_column_index: 26  
          },
          fields: "userEnteredValue"
        }
      }
      @service.batch_update_spreadsheet(
        SHEET_ID,
        Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new(
          requests: [clear_request]
        )
      )
      values = products.map do |p|
        [
          p.id.to_s,
          p.name.to_s,
          p.price.to_s,
          p.stock.to_s,
          p.category.to_s,
          p.created_by.to_s,
          p.updated_by.to_s,
          p.deleted_at&.to_s,
          p.is_deleted.to_s,
          p.created_at.to_s,
          p.updated_at.to_s
        ]
      end
      body = Google::Apis::SheetsV4::ValueRange.new(values: values)
      
      @service.update_spreadsheet_value(
        SHEET_ID,
        "Sayfa1!A2",
        body,
        value_input_option: "RAW"
      )
    end
    
    
    private
    
    def authorize
      Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open(Rails.root.join("config/google/service_account.json")),
        scope: Google::Apis::SheetsV4::AUTH_SPREADSHEETS
      )
    end

    def write_error_to_sheet(row, message)
      range = "Sayfa1!J#{row}"
      body = Google::Apis::SheetsV4::ValueRange.new(values: [[message]])

      @service.update_spreadsheet_value(
        SHEET_ID,
        range,
        body,
        value_input_option: "RAW"
      )
    end
    def sheet_id
      @sheet_id ||= begin
        spreadsheet = @service.get_spreadsheet(SHEET_ID)
        spreadsheet.sheets.first.properties.sheet_id
      end
    end



    def clear_error_from_sheet(row)
      range = "Sayfa1!J#{row}"
      body = Google::Apis::SheetsV4::ValueRange.new(values: [[""]])

      @service.update_spreadsheet_value(
        SHEET_ID,
        range,
        body,
        value_input_option: "RAW"
      )
    end
    def update_sheet_id(row, id)
      range = "Sayfa1!A#{row}"
      body = Google::Apis::SheetsV4::ValueRange.new(values: [[id]])

      @service.update_spreadsheet_value(
        SHEET_ID,
        range,
        body,
        value_input_option: "RAW"
      )
    end

    
  end
end
