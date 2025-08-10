// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
import TreeController from "./tree_controller"
application.register("tree", TreeController)
import FilterController from "./filter_controller"
application.register("filter", FilterController)
