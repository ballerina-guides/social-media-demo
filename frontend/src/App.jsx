import HomePage from "./pages/HomePage";
import ProfilesPage from "./pages/ProfilesPage";
import ErrorPage from "./pages/ErrorPage";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import ProfilePage from "./pages/ProfilePage";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<ProfilesPage />} />
        <Route path="/user/:id" element={<HomePage />} />
        <Route path="/user/:id/profile" element={<ProfilePage />} />
        <Route path="/*" element={<ErrorPage />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
