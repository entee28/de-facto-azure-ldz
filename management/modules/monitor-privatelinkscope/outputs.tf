output "monitor_private_link_scope" {
  value = {
    id = azurerm_monitor_private_link_scope.this.id
    name = azurerm_monitor_private_link_scope.this.name
  }
}