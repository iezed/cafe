import consumer from "channels/consumer"

consumer.subscriptions.create(
    { channel: "Admin::OrdersChannel" },
    {
      received(data) {
        console.log("New order received:", data)

        if (data.event === "order_created") {
          prependOrderRow(data)
        }
      }
    }
)

function prependOrderRow(order) {
    const container = document.querySelector("#orders-table tbody")

    const tEdit   = container.dataset.i18nEdit
    const tDelete = container.dataset.i18nDelete
    const tConfirmDelete = container.dataset.i18nConfirmDelete

    const row = document.createElement("tr")

    row.innerHTML = `
    <td>${order.order_id}</td>
    <td>${order.user_name}</td>
    <td>${order.payments.join(" ")}</td>
    <td>${order.products.join(" ")}</td>
    <td class="text-right">${order.payment}</td>
    <td class="text-right d-none d-sm-table-cell">${order.created_at}</td>
    <td class="text-center">
        <a class="btn btn-secondary" href="/admin/orders/${order.id}/edit">${tEdit}</a>
        <a data-confirm="${tConfirmDelete}" class="btn btn-danger" rel="nofollow" data-method="delete" href="/admin/orders/${order.id}">${tDelete}</a>
    </td>
  `

    container.prepend(row)

// 1️⃣ 먼저 highlight만
    row.classList.add("fade-highlight")

// 2️⃣ 브라우저가 한 프레임 그린 뒤 fade-out
    setTimeout(() => {
        row.classList.add("fade-out")
    }, 50)
}