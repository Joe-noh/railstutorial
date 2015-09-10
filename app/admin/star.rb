ActiveAdmin.register Star do
  permit_params :user_id, :date, :status

  form do |f|
    f.inputs "Star" do
      input :user
      input :date
      input :status, as: :select, collection: [:candidate, :accepted, :declined]
    end
    f.actions
  end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
