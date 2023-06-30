$version: "2"
//metadata validators = [
//    {
//        id: "HttpResponseCodeSemantics"
//        name: "EmitEachSelector"
////        namespace: "api.v1.software_catalog"
////        reason: "HTTP status code 303 is a valid response for SoftwareReleasesDownload operation"
//        configuration: {
//            selector: ":not([id|name = 'SoftwareReleasesDownload' i])"
//        }
//    }
//]

namespace api.v1.software_catalog

use aws.auth#StringList
use aws.protocols#restJson1

@restJson1
service SoftwareCatalog {
    version: "1.0"
    operations: [
        SoftwareDownloadsGet,
        SoftwareDownloadsHead,
        SoftwareReleasesGet,
        SoftwareReleasesList,
        SoftwareReleasesDownload,
        SoftwareReleasesSignature
    ]
// Resources can be used as a linkage between a specific entity and a set of operations
//    resources: [
//        SoftwareReleaseResource
//    ]
}

// ===========================================
// Operations
// ===========================================

@readonly
// TODO: specify multiple success status codes [200, 206]
@http(method: "GET", uri: "/api/v1/software-index/{downloadId}", code: 200)
operation SoftwareDownloadsGet {
    input: SoftwareDownloadsGetInput
    output: SoftwareDownloadsGetOutput
    errors: [
        InvalidParameterError
        NotFoundError
        UnavailableForLegalReasonsError
        InternalServerError
        ServiceUnavailableError
    ]
}

@readonly
@http(method: "HEAD", uri: "/api/v1/software-index/{downloadId}", code: 200)
operation SoftwareDownloadsHead {
    input: SoftwareDownloadsHeadInput
    output: SoftwareDownloadsHeadOutput
    errors: [
        InvalidParameterError
        NotFoundError
        InternalServerError
        ServiceUnavailableError
    ]
}

@readonly
@http(method: "GET", uri: "/api/v1/software-releases/{releaseId}", code: 200)
@documentation("Get a software component release with the given ID.")
operation SoftwareReleasesGet {
    input: SoftwareReleasesGetInput
    output: SoftwareReleasesGetOutput
    errors: [
        InvalidParameterError
        UnauthenticatedError
        ForbiddenError
        NotFoundError
        InternalServerError
        ServiceUnavailableError
    ]
}

@readonly
@http(method: "GET", uri: "/api/v1/software-releases", code: 200)
operation SoftwareReleasesList {
    input: SoftwareReleasesListInput
    output: SoftwareReleasesListOutput
    errors: [
        InvalidParameterError
        UnauthenticatedError
        ForbiddenError
        NotFoundError
        InternalServerError
        ServiceUnavailableError
    ]
}

// TODO: cannot specify 303 status code
@http(method: "POST", uri: "/api/v1/software-releases/{releaseId}/download", code: 200)
operation SoftwareReleasesDownload {
    input: SoftwareReleasesDownloadInput
    output: SoftwareReleasesDownloadOutput
    errors: [
        InvalidParameterError
        UnauthenticatedError
        ForbiddenError
        NotFoundError
        InternalServerError
        ServiceUnavailableError
    ]
}

// TODO: cannot specify 303 status code
@http(method: "POST", uri: "/api/v1/software-releases/{releaseId}/signature")
operation SoftwareReleasesSignature {
    input: SoftwareReleasesSignatureInput
    output: SoftwareReleasesSignatureOutput
    errors: [
        InvalidParameterError
        UnauthenticatedError
        ForbiddenError
        NotFoundError
        InternalServerError
        ServiceUnavailableError
    ]
}

// ===========================================
// Structures
// ===========================================

@input
structure SoftwareReleasesGetInput {
    @required
    @httpLabel
    releaseId: UUID

    @httpQuery("select")
    @documentation("A list of software release properties to include in the response separated by a `,`, e.g. `id,name`. If this is omitted, all properties shall be returned.")
    select: SelectableProperties
}

@output
structure SoftwareReleasesGetOutput {

    @httpPayload
    release: SoftwareRelease
}

@input
structure SoftwareReleasesListInput {
    @range(min: 0)
    @httpQuery("offset")
    offset:     Integer

    @range(min: 1, max: 1000)
    @httpQuery("limit")
    limit:      Integer

    @httpQuery("filter")
    filter:     String

    @length(max: 50)
    @httpQuery("sort")
    sort:       String

    @httpQuery("select")
    select: SelectableProperties
}

@output
structure SoftwareReleasesListOutput {
    pageLimit:  Integer
    pageOffset: Integer
    total:      Integer
    items:      SoftwareReleaseList
}

list SoftwareReleaseList {
    member: SoftwareRelease
}

@input
structure SoftwareReleasesDownloadInput {
    @required
    @httpLabel
    releaseId: UUID
}

@output
structure SoftwareReleasesDownloadOutput {
    @httpHeader("Location")
    location: String
}

@input
structure SoftwareReleasesSignatureInput {
    @required
    @httpLabel
    releaseId: UUID
}

@output
structure SoftwareReleasesSignatureOutput {
    @httpHeader("Location")
    location: String
}

@input
structure SoftwareDownloadsGetInput {
    @required
    @httpLabel
    downloadId: UUID

    @httpHeader("X-B3-TraceId")
    traceId: TraceID

    @httpHeader("Range")
    byteRange: String
}

@output
structure SoftwareDownloadsGetOutput {
    @httpHeader("Accept-Ranges")
    acceptRanges: String

    // TODO: Content-Length is not allowed definition
//    @httpHeader("Content-Length")
//    contentLength: String

    @httpHeader("Content-Type")
    contentType: String = "application/octet-stream"

    @httpHeader("Content-Disposition")
    contentDisposition: String

    @httpHeader("Digest")
    digest: String

    @httpPayload
    data: Blob
}

@input
structure SoftwareDownloadsHeadInput {
    @required
    @httpLabel
    downloadId: UUID

    @httpHeader("X-B3-TraceId")
    traceId: TraceID
}

@output
structure SoftwareDownloadsHeadOutput {
    @httpHeader("Accept-Ranges")
    acceptRanges: String

    // TODO: Content-Length is not allowed definition
    //    @httpHeader("Content-Length")
    //    contentLength: String

    @httpHeader("Content-Type")
    contentType: String = "application/octet-stream"

    @httpHeader("Content-Disposition")
    contentDisposition: String

    @httpHeader("Digest")
    digest: String
}

structure SoftwareRelease {
    customerId:              String
    generation:              Long
    id:                      String
    name:                    String
    resourceUri:             String
    type:                    ReleaseType
    digest:                  String
    downloadable:            Boolean
    filename:                String
    releaseDate:             String
    releaseNotesUrl:         String
    releaseType:             String
    signatureDigest:         String
    signatureFilename:       String
    signatureSizeInBytes:    Long
    sizeInBytes:             Long
    softwareComponent:       SoftwareComponent
    version:                 String
}

structure SoftwareComponent {
    customerId:     String
    generation:     Long
    id:             String
    name:           String
    type:           SoftwareComponentType
}

// ===========================================
// Structures - Errors
// ===========================================

@mixin
structure APIError {
    traceId:    String
    error:      String
}

@error("client")
@httpError(400)
@documentation("An invalid request was received.")
structure InvalidParameterError with [APIError] {
    errorCode:  String = "INVALID_PARAMETER"
}

@error("client")
@httpError(401)
@documentation("The request did not provide valid authentication.")
structure UnauthenticatedError with [APIError] {
    errorCode:  String = "UNAUTHENTICATED"
}

@error("client")
@httpError(403)
@documentation("The requesting user was not permitted to access this resource.")
structure ForbiddenError with [APIError] {
    errorCode:  String = "FORBIDDEN"
}

@error("client")
@httpError(404)
@documentation("The requested software component release does not exist.")
structure NotFoundError with [APIError] {
    errorCode:  String = "NOT_FOUND"
}

@error("client")
@httpError(459)
@documentation("The requesting user has an administrative issue accessing the resource.")
structure UnavailableForLegalReasonsError with [APIError] {
    errorCode:  String = "UNAVAILABLE_FOR_LEGAL_REASONS"
}

@error("server")
@httpError(500)
@documentation("An internal error occurred.")
structure InternalServerError with [APIError] {
    errorCode:  String = "INTERNAL_ERROR"
}

@error("server")
@httpError(503)
@documentation("Service unavailable.")
structure ServiceUnavailableError with [APIError] {
    errorCode:  String = "SERVICE_UNAVAILABLE"
}

// ===========================================
// Enums
// ===========================================

enum ReleaseType {
    INSTALL = "INSTALL"
    UPGRADE = "UPGRADE"
}

enum SoftwareComponentType {
    SOFTWARE_COMPONENT = "SoftwareComponent"
}

// ===========================================
// Specific types
// ===========================================

list SelectableProperties {
    member: String
}

string UUID

string TraceID
