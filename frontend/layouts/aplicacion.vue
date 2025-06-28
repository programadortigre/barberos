<!-- layouts/default.vue -->
<template>
  <div>
    <TopNav />
    <NuxtPage />
    <BottomNav />
  </div>
</template>
<style>
:root {
  --primary: #4361ee;
  --primary-dark: #3a56d4;
  --primary-light: #eef2ff;
  --secondary: #7209b7;
  --success: #06d6a0;
  --warning: #ff9e00;
  --danger: #ef476f;
  --dark: #212529;
  --darker: #1a1d21;
  --light: #f8f9fa;
  --lighter: #fcfcfc;
  --gray: #6c757d;
  --light-gray: #e9ecef;
  --border: #dee2e6;
  --card-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  --elevation: 0 8px 24px rgba(0, 0, 0, 0.08);
  --transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  --radius: 16px;
  --radius-sm: 12px;
  --radius-lg: 20px;
  --nav-height: 68px;
  --header-height: 60px;
  --icon-size: 52px;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  -webkit-tap-highlight-color: transparent;
}

body {
  font-family: 'Poppins', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, sans-serif;
  color: var(--dark);
  line-height: 1.6;
  min-height: 100vh;
  padding: 0;
  margin: 0;
  padding-top: var(--header-height);
  padding-bottom: var(--nav-height);
  overflow-x: hidden;
}

/*botones*/
.btn {
  display: block;
  width: 100%;
  padding: 18px;
  background: var(--primary);
  color: white;
  border: none;
  border-radius: 12px;
  font-size: 18px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 4px 10px rgba(67, 97, 238, 0.3);
  margin-top: 10px;
}

.btn:hover {
  background: var(--primary-dark);
  transform: translateY(-3px);
  box-shadow: 0 6px 15px rgba(67, 97, 238, 0.4);
}

.btn-outline {
  background: transparent;
  border: 2px solid var(--primary);
  color: var(--primary);
  box-shadow: none;
}

.btn-outline:hover {
  background: rgba(67, 97, 238, 0.1);
}
</style>