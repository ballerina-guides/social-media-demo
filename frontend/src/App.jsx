import HomePage from "./pages/HomePage"
import ProfilesPage from "./pages/ProfilesPage"
import {
  BrowserRouter,
  Route,
  Routes
} from "react-router-dom"

function App() {

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/profiles" element={<ProfilesPage />} />
      </Routes>
    </BrowserRouter>
  )
}

export default App
