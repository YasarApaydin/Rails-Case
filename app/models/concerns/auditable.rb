module Auditable
  extend ActiveSupport::Concern

  included do
    before_create :set_created_by
    before_update :set_updated_by

    scope :active, -> { where(is_deleted: false) }
  end

  def soft_delete
    update!(
      is_deleted: true,
      deleted_at: Time.current
    )
  end

  def restore
    update!(
      is_deleted: false,
      deleted_at: nil
    )
  end

  private

  def set_created_by
    self.created_by ||= Current.user&.email
  end

  def set_updated_by
    self.updated_by = Current.user&.email
  end
end
