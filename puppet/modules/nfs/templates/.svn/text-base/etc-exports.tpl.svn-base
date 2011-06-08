# templates/services/nfs/etc-exports.tpl
<% share_root.each do |shareroot| %> <%= shareroot %>  <% clientlist.each do |client| %> <%= client %>(<%= share_options %>)<% end %>
<% end %>

