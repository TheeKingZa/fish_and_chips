// script.js

document.addEventListener("DOMContentLoaded", () => {
    const menuContainer = document.getElementById("menu-container");
    const categoryContainer = document.getElementById("category-buttons");
    const searchInput = document.getElementById("search");
  
    let fullMenu = [];
  
    // Fetch menu data from JSON file
    fetch("menu.json")
      .then(response => {
        if (!response.ok) {
          throw new Error("Failed to load menu data");
        }
        return response.json();
      })
      .then(data => {
        fullMenu = data.menu || [];
        renderCategories(fullMenu);
        renderMenu(fullMenu);
      })
      .catch(error => {
        console.error("Error loading menu:", error);
        menuContainer.innerHTML = `<p style="color:red;">⚠️ Unable to load menu. Please try again later.</p>`;
      });
  
    // Function to render menu items
    function renderMenu(items) {
      menuContainer.innerHTML = "";
  
      if (!items.length) {
        menuContainer.innerHTML = `<p>No items match your search or selection.</p>`;
        return;
      }
  
      items.forEach(item => {
        // Handle null or undefined fields
        const name = item.name || "Unnamed Item";
        const description = item.description || "No description available.";
        const price = item.price != null ? `R ${item.price.toFixed(2)}` : "Price not listed";
        const image = item.image || "https://via.placeholder.com/400x300?text=No+Image";
  
        // Create card element
        const card = document.createElement("div");
        card.className = "menu-item";
        card.innerHTML = `
          <img src="${image}" alt="${name}" />
          <h3>${name}</h3>
          <p>${description}</p>
          <span class="price">${price}</span>
        `;
        menuContainer.appendChild(card);
      });
    }
  
    // Function to get unique categories
    function getUniqueCategories(menu) {
      const categories = menu.map(item => item.category || "Uncategorized");
      return ["All", ...new Set(categories)];
    }
  
    // Function to render category buttons
    function renderCategories(menu) {
      const categories = getUniqueCategories(menu);
  
      categories.forEach(category => {
        const button = document.createElement("button");
        button.textContent = category;
        button.classList.add("category-btn");
  
        button.addEventListener("click", () => {
          const filtered =
            category === "All"
              ? fullMenu
              : fullMenu.filter(item => (item.category || "Uncategorized") === category);
          renderMenu(filtered);
        });
  
        categoryContainer.appendChild(button);
      });
    }
  
    // Live search filtering
    searchInput.addEventListener("input", e => {
      const query = e.target.value.toLowerCase();
      const filtered = fullMenu.filter(item =>
        (item.name || "").toLowerCase().includes(query) ||
        (item.description || "").toLowerCase().includes(query)
      );
      renderMenu(filtered);
    });
  });
  