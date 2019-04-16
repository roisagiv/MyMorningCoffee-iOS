//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Alamofire
import Foundation
import Kanna
import RxAlamofire
import RxSwift

class KannaScraperService: ScraperService {
  func scrape(url: String) -> Single<ScrapedItem> {
    return RxAlamofire.request(.get, url)
      .validate(statusCode: 200 ..< 300)
      .responseString()
      .map { [unowned self] response in self.parse(html: response.1, url: url) }
      .asSingle()
  }

  private func parse(html: String, url: String) -> ScrapedItem {
    let dom = try? HTML(html: html, encoding: .utf8)

    let title = dom?.xpath("//head/meta[@property=\"og:title\"]").first?["content"]
    let description = dom?.xpath("//head/meta[@property=\"og:description\"]").first?["content"]
    let image = dom?.xpath("//head/meta[@property=\"og:image\"]").first?["content"]
    let date = extractDate(html: dom)
    let publisher = extractPublisher(html: dom)
    let logo = extractLogo(html: dom, baseUrl: url)
    let author = extractAuthor(html: dom)
    let scrapedUrl = extractUrl(html: dom) ?? url

    return ScrapedItem(
      publisher: publisher,
      description: description,
      url: scrapedUrl,
      coverImageUrl: image,
      datePublished: date,
      title: title,
      logo: logo,
      author: author
    )
  }

  private func extractDate(html: HTMLDocument?) -> String? {
    let xpathValue = extractByXpath(html: html, instructions: [
      ("//head/meta[@property=\"og:updated_time\"]", "content"),
      ("//head/meta[@property=\"article:modified_time\"]", "content"),
      ("//head/meta[@property=\"article:published_time\"]", "content"),
      ("//head/meta[@itemprop=\"datePublished\"]", "content"),
      ("//head/meta[@itemprop=\"dateModified\"]", "content"),
      ("//head/meta[@name=\"date\"]", "content")
    ])
    guard let dateAsString = xpathValue else {
      return xpathValue
    }
    guard let date = Dates.dateFromISO8601(iso8601: dateAsString) else {
      return dateAsString
    }
    return Dates.rfc3339(from: date)
  }

  private func extractPublisher(html: HTMLDocument?) -> String? {
    return extractByXpath(html: html, instructions: [
      ("//head/meta[@property=\"og:site_name\"]", "content")
    ])
  }

  private func extractAuthor(html: HTMLDocument?) -> String? {
    return extractByXpath(html: html, instructions: [
      ("//head/meta[@name=\"author\"]", "content")
    ])
  }

  private func extractUrl(html: HTMLDocument?) -> String? {
    return extractByXpath(html: html, instructions: [
      ("//head/meta[@property=\"og:url\"]", "content"),
      ("//head/meta[@name=\"twitter:url\"]", "content")
    ])
  }

  private func extractLogo(html: HTMLDocument?, baseUrl: String) -> String? {
    guard let icon = extractByXpath(html: html, instructions: [
      ("//head/meta[@property=\"og:logo\"]", "content"),
      ("//head/link[@rel=\"apple-touch-icon\"]", "href"),
      ("//head/meta[@itemprop=\"logo\"]", "content"),
      ("//img[@itemprop=\"logo\"]", "src"),
      ("//link[@rel=\"shortcut icon\"]", "href"),
      ("//head/link[@rel=\"icon\"]", "href")
    ]) else {
      return nil
    }

    guard let url = URLComponents(string: icon) else { return nil }

    return url.url(relativeTo: URL(string: baseUrl))?.absoluteString
  }

  private func extractByXpath(html: HTMLDocument?, instructions: [(String, String)]) -> String? {
    for instruction in instructions {
      if let elements = html?.xpath(instruction.0) {
        switch elements.count {
        case 0: break
        case 1: return elements.first?[instruction.1]
        default:
          return extractByLargestSize(elements: elements, instruction: instruction)
        }
      }
    }
    // else
    return nil
  }

  private func extractByLargestSize(elements: XPathObject, instruction: (String, String)) -> String? {
    var largest: (String?, Int) = (elements.first?[instruction.1], 0)
    for element in elements {
      if let sizes = element["sizes"], sizes.contains("x") {
        let size = Int(sizes.split(separator: "x")[0]) ?? 0
        if size > largest.1 {
          largest.0 = element[instruction.1]
          largest.1 = size
        }
      }
    }
    return largest.0
  }
}
