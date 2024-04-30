import { useState } from "react";
import HomePage from "./pages/HomePage";
import ProfilesPage from "./pages/ProfilesPage";
import { BrowserRouter, Route, Routes } from "react-router-dom";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<ProfilesPage />} />
        <Route path="/user/:id" element={<HomePage />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
