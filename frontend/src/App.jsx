import HomePage from "./pages/HomePage";
import ProfilesPage from "./pages/ProfilesPage";
import ErrorPage from "./pages/ErrorPage";
import { BrowserRouter, Route, Routes } from "react-router-dom";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<ProfilesPage />} />
        <Route path="/user/:id" element={<HomePage />} />
        <Route path="/*" element={<ErrorPage />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
