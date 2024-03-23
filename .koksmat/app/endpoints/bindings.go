// -------------------------------------------------------------------
// Generated by 365admin-publish
// -------------------------------------------------------------------

package endpoints

import (
	"net/http"

	chi "github.com/go-chi/chi/v5"
	"github.com/swaggest/rest/nethttp"
	"github.com/swaggest/rest/web"
)

func AddEndpoints(s *web.Service, jwtAuth func(http.Handler) http.Handler) {
	s.Route("/v1", func(r chi.Router) {
		r.Group(func(r chi.Router) {
			//r.Use(adminAuth, nethttp.HTTPBasicSecurityMiddleware(s.OpenAPICollector, "User", "User access"))
			r.Use(jwtAuth, nethttp.HTTPBearerSecurityMiddleware(s.OpenAPICollector, "Bearer", "", ""))
			//	r.Use(rateLimitByAppId(50))
			//r.Method(http.MethodPost, "/", nethttp.NewHandler(ExchangeCreateRoomsPost()))
			r.Method(http.MethodPost, "/health/ping", nethttp.NewHandler(HealthPingPost()))
			r.Method(http.MethodPost, "/health/coreversion", nethttp.NewHandler(HealthCoreversionPost()))
			r.Method(http.MethodPost, "/tasks/get-users-to-mfareset", nethttp.NewHandler(TasksGetUsersToMfaresetPost()))
			r.Method(http.MethodPost, "/tasks/reset-users-to-mfareset", nethttp.NewHandler(TasksResetUsersToMfaresetPost()))
			r.Method(http.MethodPost, "/azuread/reset-mfa", nethttp.NewHandler(AzureadResetMfaPost()))
			r.Method(http.MethodPost, "/deployweb/webdeployproduction", nethttp.NewHandler(DeploywebWebdeployproductionPost()))
			r.Method(http.MethodPost, "/provision/webdeployproduction", nethttp.NewHandler(ProvisionWebdeployproductionPost()))
			r.Method(http.MethodPost, "/auth/enable-disabled", nethttp.NewHandler(AuthEnableDisabledPost()))

		})
	})

}
