//
//  TopNewsViewModelSpec.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 23/08/2018.
// Copyright © 2018 Roi Sagiv. All rights reserved.
//

@testable import MyMorningCoffee
import Nimble
import Quick
import RxNimble
import RxSwift

class TopNewsViewModelSpec: QuickSpec {
  // swiftlint:disable:next function_body_length
  override func spec() {
    beforeEach {
      Fixtures.beforeEach()

      do {
        try Injector.configure()
        try DatabaseMigrations.migrate(database: Injector.databaseWriter)
      } catch {
        fail(error.localizedDescription)
      }
    }

    afterEach {
      Fixtures.afterEach()
    }

    describe("items") {
      it("should be empty at first") {
        let viewModel = Injector.topNewsViewModel
        let items = viewModel.items.asObservable()
        expect(items).first.to(beEmpty())
      }

      it("should not be empty after reload") {
        Fixtures.topStories()

        let viewModel = Injector.topNewsViewModel
        let items = viewModel.items.asObservable()
        expect(items).first.to(beEmpty())

        viewModel.refresh.onNext(())
        expect(items.skip(1)).first.to(haveCount(397))
      }

      it("should update after expanding an item") {
        Fixtures.topStories()
        Fixtures.storyItem()
        Fixtures.mercuryWebParser()

        let viewModel = Injector.topNewsViewModel
        let items = viewModel.items.asObservable()
        expect(items).first.to(beEmpty())

        let id = 17_790_031
        viewModel.refresh.onNext(())
        viewModel.loadItem.onNext(id)
        do {
          let updatedItem = try items
            .map {
              $0.first { $0.id == id } ?? TopNewsItem(id: id, title: "nil")
            }
            .debug("items", trimOutput: true)
            .skip(3)
            .toBlocking().first()

          expect(updatedItem?.description) == "Time to break out the tissues, space fans."
        } catch {
          fail(error.localizedDescription)
        }
      }
    }
  }
}
