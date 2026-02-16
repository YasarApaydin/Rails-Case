class ProductsSyncController < ApplicationController
  before_action :authenticate_user!

  # DB → SHEET
  def sync_to_sheet
    GoogleSheets::ProductsSyncService.new.sync_to_sheet
    redirect_to products_path, notice: "Database → Google Sheet sync completed"
  rescue StandardError => e
    Rails.logger.error e.message
    redirect_to products_path, alert: "DB → Sheet sync failed"
  end

  # SHEET → DB
  def sync_from_sheet
    GoogleSheets::ProductsSyncService.new.sync_from_sheet
    redirect_to products_path, notice: "Google Sheet → Database sync completed"
  rescue StandardError => e
    Rails.logger.error e.message
    redirect_to products_path, alert: "Sheet → DB sync failed"
  end
end
